package com.aline.usermicroservice.service;

import com.aline.core.dto.request.UserRegistration;
import com.aline.core.dto.response.PaginatedResponse;
import com.aline.core.dto.response.UserResponse;
import org.springframework.data.domain.Pageable;

/**
 * User service interface that provides basic CRUD method implementation.
 */
public interface UserService {
    UserResponse getUserById(Long id);
    PaginatedResponse<UserResponse> getAllUsers(Pageable pageable, String search);
    UserResponse registerUser(UserRegistration registration);
    void enableUser(Long id);
}
