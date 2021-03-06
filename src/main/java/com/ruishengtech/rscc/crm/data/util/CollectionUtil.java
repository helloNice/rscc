package com.ruishengtech.rscc.crm.data.util;

import java.util.ArrayList;
import java.util.List;

import com.ruishengtech.framework.core.db.UUID;

public class CollectionUtil {

	public static List<UUID> stringToUuid(List<String> sList) {
		List<UUID> uList = new ArrayList<UUID>();
		for(String s:sList)
			uList.add(UUID.UUIDFromString(s));
		return uList;
	}
	
	public static List<String> uuidToString(List<UUID> uList) {
		List<String> sList = new ArrayList<String>();
		for(UUID u:uList)
			sList.add(u.toString());
		return sList;
	}
		
	public static int sum(int[] nums) {
		int sum = 0;
		for(int i:nums)
			sum+=i;
		return sum;
	}
	
	public static int sum(Iterable<Integer> nums) {
		int sum = 0;
		for(Integer i:nums)
			sum+=i;
		return sum;
	}
}
