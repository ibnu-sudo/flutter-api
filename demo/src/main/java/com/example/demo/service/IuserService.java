package com.example.demo.service;

import java.util.List;

import com.example.demo.model.usermodel;

public interface IuserService {
	public usermodel insertUser(usermodel user);
	public List<usermodel> getAlluser();
	public usermodel updateUser (long id, usermodel user);
	public usermodel deleteUser (long id);

}
