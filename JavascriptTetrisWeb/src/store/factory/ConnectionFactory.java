package store.factory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
	
	private static ConnectionFactory instance;
	
	private static final String DRIVER_NAME = "oracle.jdbc.driver.OracleDriver";
	private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	private static final String USER_NAME = "test";
	private static final String PASSWORD = "test";
	
	private ConnectionFactory() {
		try {
			Class.forName(DRIVER_NAME);
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new RuntimeException("드라이버 로딩 오류");
			
		}
	}
	
	public static ConnectionFactory getInstance() {
		if(instance == null) {
			instance = new ConnectionFactory();
		}
		return instance;
	}
	
	// java.sql의 Connection을 import 해야 한다. 
	// ※ 작성할 때 리턴 코드를 먼저쓰고 빨간 동그라미 누른 후 익셉션 처리를 throw로 해주면 throw SQLException이 자동으로 생긴다.
	public Connection createConnection() throws SQLException {
		return DriverManager.getConnection(URL, USER_NAME, PASSWORD);
	}
}
