package com.example.demo.repository;

import java.util.List;

import com.example.demo.model.usermodel;

public interface IuserRepo {
	
	public usermodel insertUser(usermodel user);
	public List<usermodel> getAlluser();
	public usermodel updateUser (long id, usermodel user);
	public usermodel deleteUser (long id);

}
