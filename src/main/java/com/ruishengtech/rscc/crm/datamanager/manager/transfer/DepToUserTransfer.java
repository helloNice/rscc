package com.ruishengtech.rscc.crm.datamanager.manager.transfer;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.ruishengtech.framework.core.QueryUtils;
import com.ruishengtech.rscc.crm.datamanager.manager.TransferResult;
import com.ruishengtech.rscc.crm.datamanager.manager.node.BatchNode;
import com.ruishengtech.rscc.crm.datamanager.manager.node.DepNode;
import com.ruishengtech.rscc.crm.datamanager.manager.node.UserNode;
import com.ruishengtech.rscc.crm.datamanager.manager.transferdata.DepToUserData;

/**
 * Created by yaoliceng on 2015/8/18.
 */
@Component
@Transactional
public class DepToUserTransfer extends AbstractTransfer<DepNode, UserNode, DepToUserData> {

	@Override
	public TransferResult transfer(DepNode fromNode, UserNode toNode, DepToUserData transferData) {
		int count;
		if(transferData.getDatas() == null) {
			count = cut(fromNode.getTableName(), toNode.getTableName(), transferData.getBatchUuid(), transferData.getTransferNum());
		} else {
			count = cutByDatas(fromNode.getTableName(), toNode.getTableName(), transferData.getBatchUuid(), transferData.getDatas());
		}
    	
    	TransferResult tr = new TransferResult();
    	tr.setTransferCount(count);
    	
    	return tr;
	}

	//二级分配要选一个批次
    private int cut(String sourceTable, String targetTable, String batchUuid, int num) {
		if(num <= 0)
			return 0;
		//二级领用到人，插入数据
		// 给(new_data_department_user_当前部门UUID)插入数据,数据来源是(new_data_department_当前部门UUID)
		String insertSql = "insert into " + UserNode.tablePrefix + sourceTable + 
				"(uuid,batch_uuid,phone_number,json,own_department,own_department_timestamp,own_user,own_user_timestamp) "
				+ "(select uuid,batch_uuid,phone_number,json,own_department,own_department_timestamp,? own_user,NOW() own_user_timestamp from " 
				+ DepNode.tablePrefix + sourceTable + " where batch_uuid=? and is_lock != '1' order by uuid limit ? )";
		
		// 删除数据
		// 删除(new_data_department_当前部门UUID)的数据
		String deleteSql = "delete from " + DepNode.tablePrefix + sourceTable + " where batch_uuid=? and is_lock !='1' order by uuid limit ?";
		
		//更新数据，数据同步原则：保证两个表中选出来的内容一致。时间有可能不一致，在外部定义变量是最好的方法。
		String updateSql = "update " + BatchNode.tablePrefix + batchUuid + " set own_user=?,own_user_timestamp=NOW() "
				+ "where own_department=? and own_user is null and is_abandon != '1' "
				+ "and customer_uuid is null and is_blacklist != '1' and is_frozen != '1' and is_lock != '1' order by uuid limit ?";
		int updateCount = jdbcTemplate.update(insertSql, targetTable, batchUuid, num);
		if (updateCount == 0) {
			return updateCount;
		}
		jdbcTemplate.update(deleteSql, batchUuid, updateCount);
		jdbcTemplate.update(updateSql, targetTable, sourceTable, updateCount);
		synchronzineData(batchUuid, sourceTable, targetTable, updateCount);
		return updateCount;
    }
    
 	private int cutByDatas(String sourceTable, String targetTable, String batchUuid, Collection<String> datas) {
 		//二级领用到人，插入数据
 		List<Object> insertParam = new ArrayList<>();
 		List<Object> deleteParam = new ArrayList<>();
		List<Object> updateParam = new ArrayList<>();
		//插入数据
		insertParam.add(targetTable);
		insertParam.add(batchUuid);
		String insertSql = "insert into " + UserNode.tablePrefix + sourceTable + 
				"(uuid,batch_uuid,phone_number,json,own_department,own_department_timestamp,own_user,own_user_timestamp) "
				+ "(select uuid,batch_uuid,phone_number,json,own_department,own_department_timestamp,? own_user,NOW() own_user_timestamp from " 
				+ DepNode.tablePrefix + sourceTable + " where batch_uuid=? and is_lock != '1' and " 
				+ QueryUtils.inString("uuid ", insertParam, datas) +" )";
		//删除数据
		deleteParam.add(batchUuid);
		String deleteSql = "delete from " + DepNode.tablePrefix + sourceTable + " where batch_uuid=? and is_lock !='1' and " 
				+ QueryUtils.inString("uuid ", deleteParam, datas);
		//更新数据，数据同步原则：保证两个表中选出来的内容一致。时间有可能不一致，在外部定义变量是最好的方法。
		
		updateParam.add(targetTable);
		updateParam.add(sourceTable);
		String updateSql = "update " + BatchNode.tablePrefix + batchUuid + " set own_user=?,own_user_timestamp=NOW() "
				+ "where own_department=? and own_user is null and is_abandon != '1' "
				+ "and customer_uuid is null and is_blacklist != '1' and is_frozen != '1' and is_lock != '1' and " 
				+ QueryUtils.inString("uuid ", updateParam, datas);
		int updateCount = jdbcTemplate.update(insertSql, insertParam.toArray());
		if (updateCount == 0) {
			return updateCount;
		}
		jdbcTemplate.update(deleteSql, deleteParam.toArray());
		jdbcTemplate.update(updateSql, updateParam.toArray());
		synchronzineData(batchUuid, sourceTable, targetTable, updateCount);
		return updateCount;
 	}

	@Override
	public void synchronzineData(String batchUuid, String depUuid, String userUuid, Integer count) {
		addData(null, null, null, userUuid, count);
		addOwn(null, batchUuid, depUuid, count);
	}
	
    private void synchronzineData(String batchUuid, String sourceTable, String targetTable) {
    	//这三句有一句有问题
    	synchronizeDataBatch(batchUuid);
    	synchronizeDepartmentTable(sourceTable);
    	synchronizeUserTask(sourceTable, targetTable);
    }

}
