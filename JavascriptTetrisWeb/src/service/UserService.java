package service;

import java.util.List;

import domain.User;
import store.logic.UserStore;

public class UserService {

	private UserStore store;
	
	public UserService() {
		store = new UserStore();
	}
	
	public List<User> findAll() {
		return store.selectAll();
	}
}
