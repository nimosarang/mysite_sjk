package com.javaex.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.javaex.vo.BoardVo;

public class BoardDaoImpl implements BoardDao {
    private Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
            conn = DriverManager.getConnection(dburl, "eddy", "oracle");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC 드라이버 로드 실패!");
        }
        return conn;
    }

    public List<BoardVo> getList(int from, int to, String keyField, String keyWord) {

        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BoardVo> list = new ArrayList<BoardVo>();

        try {
            conn = getConnection();

            if (keyWord == null || keyWord.equals("")) {

                String sql = "SELECT * \r\n" +
                        "       FROM(\r\n" +
                        "                SELECT ROWNUM AS RNUM, A.*\r\n" +
                        "                  FROM ( select b.no, b.title, b.hit, b.reg_date, b.user_no, u.name" +
                        "                           from board b, users u" +
                        "                          where b.user_no = u.no  " +
                        "                       order by no desc ) A\r\n" +
                        "                 WHERE ROWNUM <= ?+?\r\n" +
                        "            )\r\n" +
                        "       WHERE RNUM > ?";


                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, from);
                pstmt.setInt(2, to);
                pstmt.setInt(3, from);
            } else { //http://localhost:8088/mysite/board?keyField=name&keyWord=%EC%BD%94%EC%8A%A4%ED%83%80&nowPage=1&a=list
                String sql = " SELECT * \r\n" +
                        "      FROM(\r\n" +
                        "                SELECT ROWNUM AS RNUM, A.*\r\n" +
                        "                  FROM ( select b.no, b.title, b.hit, b.reg_date, b.user_no, u.name" +
                        "                           from board b, users u" +
                        "                          where b.user_no = u.no  " +
                        "                            and " + keyField + " like ?" +
                        "                       order by no desc ) A\r\n" +
                        "                 WHERE ROWNUM <= ?+?\r\n" +
                        "           )\r\n" +
                        "      WHERE RNUM > ?";

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyWord + "%");
                pstmt.setInt(2, from);
                pstmt.setInt(3, to);
                pstmt.setInt(4, from);
            }

            rs = pstmt.executeQuery();
            // 4.결과처리
            while (rs.next()) {
                int no = rs.getInt("no");
                String title = rs.getString("title");
                int hit = rs.getInt("hit");
                String regDate = rs.getString("reg_date");
                int userNo = rs.getInt("user_no");
                String userName = rs.getString("name");

                BoardVo vo = new BoardVo(no, title, hit, regDate, userNo, userName);
                list.add(vo);
            }

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }

        }

        return list;

    }


    public BoardVo getBoard(int no) {

        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BoardVo boardVo = null;

        try {
            conn = getConnection();

            // 3. SQL문 준비 / 바인딩 / 실행
            String query = "select b.no, b.title, b.content, b.hit, b.reg_date, b.user_no, u.name "
                    + "from board b, users u "
                    + "where b.user_no = u.no "
                    + "and b.no = ?";

            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, no);

            rs = pstmt.executeQuery();
            // 4.결과처리
            while (rs.next()) {
                String title = rs.getString("title");
                String content = rs.getString("content");
                int hit = rs.getInt("hit");
                String regDate = rs.getString("reg_date");
                int userNo = rs.getInt("user_no");
                String userName = rs.getString("name");

                boardVo = new BoardVo(no, title, content, hit, regDate, userNo, userName);
            }

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }

        }
        System.out.println(boardVo);
        return boardVo;

    }

    public int insert(BoardVo vo) {
        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        int count = 0;

        try {
            conn = getConnection();

            System.out.println("vo.userNo : [" + vo.getUserNo() + "]");
            System.out.println("vo.title : [" + vo.getTitle() + "]");
            System.out.println("vo.content : [" + vo.getContent() + "]");

            // 3. SQL문 준비 / 바인딩 / 실행
            String query = "insert into board values (seq_board_no.nextval, ?, ?, 0, sysdate, ?)";
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, vo.getTitle());
            pstmt.setString(2, vo.getContent());
            pstmt.setInt(3, vo.getUserNo());


            count = pstmt.executeUpdate();

            // 4.결과처리
            System.out.println(count + "건 등록");

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }

        }

        return count;
    }


    public int delete(int no) {
        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        int count = 0;

        try {
            conn = getConnection();

            // 3. SQL문 준비 / 바인딩 / 실행
            String query = "delete from board where no = ?";
            pstmt = conn.prepareStatement(query);

            pstmt.setInt(1, no);

            count = pstmt.executeUpdate();

            // 4.결과처리
            System.out.println(count + "건 삭제");

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }

        }

        return count;
    }


    public int update(BoardVo vo) {
        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        int count = 0;

        try {
            conn = getConnection();

            // 3. SQL문 준비 / 바인딩 / 실행
            String query = "update board set title = ?, content = ? where no = ? ";
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, vo.getTitle());
            pstmt.setString(2, vo.getContent());
            pstmt.setInt(3, vo.getNo());

            count = pstmt.executeUpdate();

            // 4.결과처리
            System.out.println(count + "건 수정");

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }

        }

        return count;
    }

    @Override
    public int getTotal() {
        int count = 0;

        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // 3. SQL문 준비 / 바인딩 / 실행
            String query = "select count(*) count from BOARD";
            pstmt = conn.prepareStatement(query);

            rs = pstmt.executeQuery();

            if (rs.next()){
                count = rs.getInt("count");
                System.out.println("총 게시물 수 : " + count);
            }

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }
        }
        return count;
    }

    @Override
    public int updateHit(int no) {
        // 0. import java.sql.*;
        Connection conn = null;
        PreparedStatement pstmt = null;
        int count = 0;

        try {
            conn = getConnection();

            // 3. SQL문 준비 / 바인딩 / 실행
            String query = "update board set hit = hit+1 where no = ? ";
            pstmt = conn.prepareStatement(query);

            pstmt.setInt(1, no);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("error:" + e);
        } finally {
            // 5. 자원정리
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("error:" + e);
            }
        }
        return count;
    }

}
