package dao;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import model.AdminModel;
import util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    private Connection connection;

    public AdminDAO() {
        try {
            this.connection = DatabaseUtil.getConnection();
        } catch (SQLException exception) {
            exception.printStackTrace();
        }
    }

    public AdminModel makeUserLogin(HttpServletRequest request) {

        AdminModel adminModel = null;
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {

            PreparedStatement preparedStatement = this.connection.prepareStatement("select * from Admin where email = ? and password = ?");
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                adminModel = new AdminModel(
                        resultSet.getInt("admin_id"),
                        resultSet.getString("username"),
                        resultSet.getLong("mobile_no"),
                        resultSet.getString("email"),
                        resultSet.getString("full_name"),
                        resultSet.getString("role")
                );
                
                return adminModel;
            }else{
                
                return null;
            }

        } catch (Exception exception) {
            exception.printStackTrace();
            return null;

        }

        
    }

    public List<AdminModel> getAllAdminInfo() {
        List<AdminModel> adminModels = new ArrayList<>();
        PreparedStatement preparedStatement;
        ResultSet resultSet;

        try {
            preparedStatement = this.connection.prepareStatement("select * from Admin");
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                adminModels.add(
                        new AdminModel(
                                resultSet.getInt("admin_id"),
                                resultSet.getString("username"),
                                resultSet.getString("password"),
                                resultSet.getLong("mobile_no"),
                                resultSet.getString("email"),
                                resultSet.getString("full_name"),
                                resultSet.getString("role"),
                                resultSet.getTimestamp("created_at"),
                                resultSet.getTimestamp("updated_at")
                        )
                );

            }

            if (adminModels.size() > 0) {
                System.out.println(adminModels.size());
                return adminModels;

            }

        } catch (Exception exception) {
            System.out.println("");
            exception.printStackTrace();
        }

        return adminModels;
    }

    public List<AdminModel> getAdminById(String adminId) {
        List<AdminModel> adminInfo = new ArrayList<>();

        try {

            PreparedStatement preparedStatement = this.connection.prepareStatement("select * from Admin where admin_id = ? ");
            preparedStatement.setInt(1, Integer.parseInt(adminId));
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                adminInfo.add(
                        new AdminModel(
                                resultSet.getInt("admin_id"),
                                resultSet.getString("username"),
                                resultSet.getLong("mobile_no"),
                                resultSet.getString("email"),
                                resultSet.getString("full_name"),
                                resultSet.getString("role")
                        )
                );
            }

            if (adminInfo.size() > 0) {
                return adminInfo;
            } else {

            }

        } catch (Exception exception) {
            System.out.println("Error : " + exception.getMessage());
            exception.printStackTrace();
        }

        return adminInfo;
    }

}
