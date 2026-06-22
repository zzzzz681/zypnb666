-- AI 简历分析与优化系统初始化数据
SET NAMES utf8mb4;

INSERT INTO sys_role (id, role_code, role_name, description) VALUES
(1, 'SUPER_ADMIN', '超级管理员', '拥有全部后台权限'),
(2, 'OPS_ADMIN', '运营管理员', '用户、内容、岗位、模板、公告管理'),
(3, 'MAINT_ADMIN', '运维管理员', '日志、监控、数据统计管理');

INSERT INTO sys_admin (id, username, password, role_id, phone, email, force_reset_password, status) VALUES
(1, 'super_admin', '$2a$10$EqKcp1WFKVQISheBxmXNGexPR.i7QYXOJC.OFfQDT8iSaHuuPdlrW', 1, '13800000001', 'super_admin@example.com', 0, 1),
(2, 'ops_admin', '$2a$10$EqKcp1WFKVQISheBxmXNGexPR.i7QYXOJC.OFfQDT8iSaHuuPdlrW', 2, '13800000002', 'ops_admin@example.com', 0, 1),
(3, 'maint_admin', '$2a$10$EqKcp1WFKVQISheBxmXNGexPR.i7QYXOJC.OFfQDT8iSaHuuPdlrW', 3, '13800000003', 'maint_admin@example.com', 0, 1);

INSERT INTO sys_user (id, username, nickname, password, phone, email, gender, target_city, target_industry, expected_salary, status) VALUES
(1001, 'demo_user', '求职加速中', '$2a$10$EqKcp1WFKVQISheBxmXNGexPR.i7QYXOJC.OFfQDT8iSaHuuPdlrW', '13800001234', 'demo_user@example.com', '保密', '上海', '互联网', '12k-18k', 1);
