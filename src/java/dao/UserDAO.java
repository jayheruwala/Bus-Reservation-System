package dao;

import java.sql.*;
import util.DatabaseUtil;
import model.User;

public class UserDAO {

    public User getUserByUserName(String userName) {
        User user = null;
        Connection connection = null;
        try {
            connection = DatabaseUtil.getConnection();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        if (connection != null) {
            try {
                PreparedStatement stmt = connection.prepareStatement("select * from users where email=?");
                stmt.setString(1, userName);
                
                ResultSet resultSet = stmt.executeQuery();
                if(resultSet.next()){
                    user = new User();
                    user.setUser_id(resultSet.getLong("user_id"));
                    user.setName(resultSet.getString("name"));
                    user.setContact_number(resultSet.getString("contact_number"));
                    user.setEmail(resultSet.getString("email"));
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return user;
    }

}
