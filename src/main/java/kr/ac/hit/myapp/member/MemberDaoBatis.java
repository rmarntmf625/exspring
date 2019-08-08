package kr.ac.hit.myapp.member;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

//@Repository
public class MemberDaoBatis implements MemberDao {
	@Resource
	private SqlSession sqlSession;

	@Override
	public int insert(MemberVo vo) {
		// MyBatis를 사용하여 insert 쿼리문을 실행하도록 구현
		// 실행하려는 SQL문에 맞는 SqlSession 객체의 메서드를 사용하여 실행
		// 실행하려는 SQL문을 "mapper네임스페이스.sql문id" 형태로 지정
		return sqlSession.insert("kr.ac.hit.myapp.member.MemberDao.insert", vo);
	}

	@Override
	public List<MemberVo> selectList() {
		return sqlSession.selectList("kr.ac.hit.myapp.member.MemberDao.selectList");
		
	}

	@Override
	public MemberVo select(String memId) {
		return sqlSession.selectOne("실행할SQL문ID", memId );
	}

}





