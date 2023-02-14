package com.javaex.dao;

import java.util.List;
import com.javaex.vo.BoardVo;

public interface BoardDao {
	public List<BoardVo> getList(int start,int end,String keyField,String keyWord);  // 게시물 전체 목록 조회
	public BoardVo getBoard(int no); // 게시물 상세 조회
	public int insert(BoardVo vo);   // 게시물 등록
	public int delete(int no);       // 게시물 삭제
	public int update(BoardVo vo);   // 게시물 수정
	public int getTotal(); //전체 글의 수 얻기
	public int updateHit(int no); // 조회수 증가


}
