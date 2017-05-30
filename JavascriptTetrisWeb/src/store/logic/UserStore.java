package store.logic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import domain.User;
import store.factory.ConnectionFactory;
import store.util.JdbcUtils;

public class UserStore {

	private ConnectionFactory factory;
	
	public UserStore() {
		factory = ConnectionFactory.getInstance();
	}
	
	public List<User> selectAll() {
		
		ArrayList<User> userList = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = factory.createConnection();

			String sql = "select id, name, score from user_tb order by score desc";
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				User user = new User();

				user.setId(rs.getInt("id"));
				user.setName(rs.getString("name"));
				user.setScore(rs.getInt("score"));

				userList.add(user);
			}

		} catch (SQLException e) {
			e.printStackTrace();

		} finally {
			JdbcUtils.close(pstmt, conn, rs);
		}

		return userList;
	}
}
