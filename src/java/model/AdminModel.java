package model;

import java.sql.Timestamp;


public class AdminModel {
    private int admin_id;
    private String username;
    private String password;
    private long mobile_no;
    private String email;
    private String full_name;
    private String role;
    private Timestamp created_at;
    private Timestamp updated_at;

    // Default constructor
    public AdminModel() {
    }

    // Parameterized constructor
    public AdminModel(int admin_id, String username, String password, long mobile_no, 
                     String email, String full_name, String role, Timestamp created_at, 
                     Timestamp updated_at) {
        this.admin_id = admin_id;
        this.username = username;
        this.password = password;
        this.mobile_no = mobile_no;
        this.email = email;
        this.full_name = full_name;
        this.role = role;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }
    
    public AdminModel(int admin_id, String username, long mobile_no, 
                     String email, String full_name, String role) {
        this.admin_id = admin_id;
        this.username = username;
      
        this.mobile_no = mobile_no;
        this.email = email;
        this.full_name = full_name;
        this.role = role;
       
    }

    // Getters and Setters
    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public long getMobile_no() {
        return mobile_no;
    }

    public void setMobile_no(long mobile_no) {
        this.mobile_no = mobile_no;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    // Optional: toString for debugging
    @Override
    public String toString() {
        return "AdminModel{" +
               "admin_id=" + admin_id +
               ", username='" + username + '\'' +
               ", password='" + password + '\'' +
               ", mobile_no=" + mobile_no +
               ", email='" + email + '\'' +
               ", full_name='" + full_name + '\'' +
               ", role='" + role + '\'' +
               ", created_at=" + created_at +
               ", updated_at=" + updated_at +
               '}';
    }
}
