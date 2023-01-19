package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.usermodel;
import com.example.demo.service.IuserService;

@RestController
@CrossOrigin(origins = "http://localhost:8080")
@RequestMapping("api/user")
public class userController {
	
	@Autowired
	IuserService iuserService;
	
	@PostMapping("/insert")
	public usermodel insertUser(@RequestBody usermodel user) {
		return iuserService.insertUser(user);
	}
	
	@GetMapping("/getAll")
	public List<usermodel> getAlluser(){
		return iuserService.getAlluser();
	}
	
	@PutMapping("/update/{id}")
	public usermodel updateUser(@PathVariable long id, @RequestBody usermodel user) {
		return iuserService.updateUser(id, user);
	}
	
	@DeleteMapping("/delete/{id}")
	public usermodel deleteUser (@PathVariable long id) {
		return iuserService.deleteUser(id);
		
	}
}
