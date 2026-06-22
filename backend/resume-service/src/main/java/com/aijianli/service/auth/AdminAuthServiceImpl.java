package com.aijianli.service.auth;

import com.aijianli.common.constant.RoleConstant;
import com.aijianli.common.exception.BusinessException;
import com.aijianli.common.exception.ErrorCode;
import com.aijianli.common.util.JwtUtil;
import com.aijianli.dto.request.LoginRequest;
import com.aijianli.dto.response.AuthResponse;
import com.aijianli.entity.AdminUser;
import com.aijianli.entity.SysRole;
import com.aijianli.mapper.AdminUserMapper;
import com.aijianli.mapper.SysRoleMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminAuthServiceImpl implements AdminAuthService {

    private final JwtUtil jwtUtil;
    private final AdminUserMapper adminUserMapper;
    private final SysRoleMapper sysRoleMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public AuthResponse login(LoginRequest request) {
        AdminUser adminUser = adminUserMapper.selectOne(
                new LambdaQueryWrapper<AdminUser>()
                        .eq(AdminUser::getUsername, request.getAccount())
                        .eq(AdminUser::getDeleted, 0)
        );
        
        if (adminUser == null) {
            throw new BusinessException(ErrorCode.UNAUTHORIZED, "账号或密码错误");
        }
        
        if (!passwordEncoder.matches(request.getPassword(), adminUser.getPassword())) {
            throw new BusinessException(ErrorCode.UNAUTHORIZED, "账号或密码错误");
        }
        
        if (adminUser.getStatus() == null || adminUser.getStatus() != 1) {
            throw new BusinessException(ErrorCode.FORBIDDEN, "账号已被禁用");
        }
        
        SysRole role = sysRoleMapper.selectOne(
                new LambdaQueryWrapper<SysRole>()
                        .eq(SysRole::getId, adminUser.getRoleId())
                        .eq(SysRole::getDeleted, 0)
        );
        
        String roleCode = RoleConstant.ROLE_ADMIN;
        if (role != null) {
            roleCode = "ROLE_" + role.getRoleCode();
        }
        
        String token = jwtUtil.generateToken(adminUser.getUsername(), Map.of("role", roleCode));
        
        adminUser.setLastLoginTime(LocalDateTime.now());
        adminUserMapper.updateById(adminUser);
        
        return new AuthResponse(token, roleCode, adminUser.getUsername());
    }
}
