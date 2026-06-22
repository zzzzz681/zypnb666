-- AI 简历分析与优化系统数据库脚本
-- MySQL 8.0+

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS score_rule;
DROP TABLE IF EXISTS system_config;
DROP TABLE IF EXISTS system_log;
DROP TABLE IF EXISTS popup_config;
DROP TABLE IF EXISTS knowledge_article;
DROP TABLE IF EXISTS announcement;
DROP TABLE IF EXISTS template_favorite;
DROP TABLE IF EXISTS resume_template;
DROP TABLE IF EXISTS job_favorite;
DROP TABLE IF EXISTS job_skill;
DROP TABLE IF EXISTS job_info;
DROP TABLE IF EXISTS industry_category;
DROP TABLE IF EXISTS ai_call_log;
DROP TABLE IF EXISTS ai_config;
DROP TABLE IF EXISTS analysis_record;
DROP TABLE IF EXISTS resume_score;
DROP TABLE IF EXISTS resume_parse_content;
DROP TABLE IF EXISTS resume_file;
DROP TABLE IF EXISTS admin_log;
DROP TABLE IF EXISTS sys_role_permission;
DROP TABLE IF EXISTS sys_permission;
DROP TABLE IF EXISTS sys_role;
DROP TABLE IF EXISTS sys_admin;
DROP TABLE IF EXISTS user_feedback;
DROP TABLE IF EXISTS user_message;
DROP TABLE IF EXISTS sys_user;

CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户主键',
    username VARCHAR(64) NOT NULL COMMENT '用户名，唯一',
    nickname VARCHAR(64) DEFAULT NULL COMMENT '昵称',
    password VARCHAR(255) NOT NULL COMMENT '密码密文',
    phone VARCHAR(128) DEFAULT NULL COMMENT '手机号密文',
    email VARCHAR(128) DEFAULT NULL COMMENT '邮箱密文',
    gender VARCHAR(16) DEFAULT '保密' COMMENT '性别',
    avatar_url VARCHAR(255) DEFAULT NULL COMMENT '头像地址',
    target_city VARCHAR(128) DEFAULT NULL COMMENT '求职意向城市',
    target_industry VARCHAR(128) DEFAULT NULL COMMENT '求职意向行业',
    expected_salary VARCHAR(64) DEFAULT NULL COMMENT '期望薪资',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '账号状态：1启用 0禁用',
    lock_until DATETIME DEFAULT NULL COMMENT '临时锁定截止时间',
    last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标识：0未删 1已删',
    UNIQUE KEY uk_sys_user_username (username),
    KEY idx_sys_user_phone (phone),
    KEY idx_sys_user_email (email),
    KEY idx_sys_user_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='C 端用户表';

CREATE TABLE sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色主键',
    role_code VARCHAR(64) NOT NULL COMMENT '角色编码',
    role_name VARCHAR(64) NOT NULL COMMENT '角色名称',
    description VARCHAR(255) DEFAULT NULL COMMENT '角色说明',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标识',
    UNIQUE KEY uk_sys_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

CREATE TABLE sys_admin (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '管理员主键',
    username VARCHAR(64) NOT NULL COMMENT '管理员账号',
    password VARCHAR(255) NOT NULL COMMENT '管理员密码密文',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    phone VARCHAR(128) DEFAULT NULL COMMENT '手机号密文',
    email VARCHAR(128) DEFAULT NULL COMMENT '邮箱密文',
    force_reset_password TINYINT NOT NULL DEFAULT 0 COMMENT '是否强制定期改密',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0禁用',
    last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(64) DEFAULT NULL COMMENT '最后登录IP',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标识',
    UNIQUE KEY uk_sys_admin_username (username),
    KEY idx_sys_admin_role_id (role_id),
    CONSTRAINT fk_sys_admin_role FOREIGN KEY (role_id) REFERENCES sys_role(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

CREATE TABLE resume_file (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '简历文件主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    file_name VARCHAR(255) NOT NULL COMMENT '原始文件名',
    storage_url VARCHAR(500) NOT NULL COMMENT '对象存储URL',
    file_type VARCHAR(16) NOT NULL COMMENT '文件格式',
    file_size BIGINT NOT NULL COMMENT '文件大小，单位字节',
    parse_status VARCHAR(32) NOT NULL DEFAULT 'PENDING' COMMENT '解析状态',
    review_status VARCHAR(32) NOT NULL DEFAULT 'NORMAL' COMMENT '审核状态',
    upload_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    expire_time DATETIME DEFAULT NULL COMMENT '过期时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标识',
    KEY idx_resume_file_user_id (user_id),
    CONSTRAINT fk_resume_file_user FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='简历文件表';

CREATE TABLE resume_score (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评分主键',
    resume_file_id BIGINT NOT NULL COMMENT '简历文件ID',
    completeness_score DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '简历完整性得分',
    content_quality_score DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '内容质量得分',
    language_score DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '语言规范性得分',
    risk_score DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '合规性与风险检测得分',
    layout_score DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '排版格式得分',
    total_score DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '综合总分',
    score_level VARCHAR(32) NOT NULL COMMENT '简历等级',
    issue_summary JSON DEFAULT NULL COMMENT '问题摘要',
    strength_summary JSON DEFAULT NULL COMMENT '亮点摘要',
    suggestion_summary JSON DEFAULT NULL COMMENT 'AI 优化建议',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除标识',
    KEY idx_resume_score_resume_file_id (resume_file_id),
    CONSTRAINT fk_resume_score_file FOREIGN KEY (resume_file_id) REFERENCES resume_file(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='简历评分结果表';

SET FOREIGN_KEY_CHECKS = 1;
