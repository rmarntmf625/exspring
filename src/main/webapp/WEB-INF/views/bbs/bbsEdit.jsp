<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/comm/menu.jsp"%>
	<h1>글 상세정보</h1>
	<form action="${pageContext.request.contextPath}/bbs/edit.do"
		method="post">
		<input type="hidden" name="bbsNo" value="${bbsVo.bbsNo }" />
		<table border="1">
			<tbody>
				<tr>
					<td>제목</td>
					<td><input type="text" name="bbsTitle"
						value="${bbsVo.bbsTitle }"
						${ loginUser.memId != bbsVo.bbsWriter ? 'disabled' : ''} /></td>
				</tr>
				<tr>
					<td>내용</td>
					<td><textarea rows="20" cols="80" name="bbsContent"
							${ loginUser.memId != bbsVo.bbsWriter ? 'disabled' : ''}>${bbsVo.bbsContent }</textarea></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td><input type="text" name="bbsWriter"
						value="${bbsVo.bbsWriter }" disabled="disabled" /></td>
				</tr>
				<!-- c:forEach의 현재 반복 상태를 저장할 변수 이름을 varStatus 속성값으로 지정 -->
				<c:forEach var="avo" items="${bbsVo.attList}" varStatus="stat">
					<tr>
						<td>첨부파일${stat.count}</td>
						<td><a
							href="${pageContext.request.contextPath}/bbs/down.do?attNo=${avo.attNo}">${avo.attOrgName }</a></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<c:if test="${loginUser.memId == bbsVo.bbsWriter}">
			<input type="submit" value="저장" />
			<a
				href="${pageContext.request.contextPath}/bbs/del.do?bbsNo=${bbsVo.bbsNo }"><input
				type="button" value="삭제" /></a>
		</c:if>
		<a href="${pageContext.request.contextPath}/bbs/list.do"><input
			type="button" value="게시글목록" /></a>
	</form>

	<hr />
	<form action="" id="repForm">
		<textarea rows="5" cols="100" name="repContent"></textarea>
		<input type="button" value="저장" id="repAddBtn" /> 
		<input type="hidden" name="repBbsNo" value="${bbsVo.bbsNo }" />
	</form>
	
	<div id="repDiv">
<!-- 	<hr/> -->
<!-- 	<div> -->
<!-- 	<span>a001</span> <span>2019/08/08 11:03:30</span> -->
<!-- 	</div> -->
<!-- 	<div> -->
<!-- 	댓글 테스트 -->
<!-- 	</div> -->
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/resources/js/jquery-3.4.1.js"></script>
	<script type="text/javascript">
	
// 	1.현재 보고 있는 게시글의 댓글들만 받아와서 화면에 출력하도록 변경
// 	- 댓글 목록 조회시 파라미터로 부모글 번호를 전송
// 	-컨트롤러에서 파라미터를 받아서 Mapper까지 전달하여 SQL문에 적용
// 	2.댓글을 추가하면, 저장 성공시 다시 댓글 목록을 받아와서 화면에 출력
// 	3.로그인한 사용자가 작성한 댓글에는 삭제 버튼을 추가하여 화면에 출력
// 	- 삭제버튼을 클릭하면 로그인한 사용자가 작성한 댓글만 삭제되도록 구현ㄴ
// 	- 삭제 성공시 다시 댓글 목록을 받아와서 화면에 출력
	
	function refreshReplyList() {		
	
	$.ajax({
        url: '${pageContext.request.contextPath}/reply/list.do',//요청주소
        method: 'GET', //요청방식(GET,POST,PUT,DELETE,.....)
        data : {repBbsNo : ${bbsVo.bbsNo}}, 
        dataType: 'json' //요청응답으로 받을 데이터 타입(text,html,json,xml,...)

    })
        .done(function (data, status, jqXHR) {
            console.log('요청성공 : ');
            console.log(data);
            var repList = data;
            //기존댓글들을 화면에서 삭제
            var $repDiv = $('#repDiv').empty();
            for(var i = 0; i<repList.length; i++){
            	var rep = repList[i];
            	$('<hr>').appendTo($repDiv);
            	var $div1 = $('<div1>').appendTo($repDiv); // <div></div>
            	$('<span>').html(rep.repWriter).appendTo($div1); // <span>a001</span>
            	$div1.append(' '); // 공백
            	$('<span>').html(rep.repDate).appendTo($div1); // <span>2019/08/08...</span>
            	$div1.append(' ');
            	if (rep.repWriter === '${loginUser.memId}') {//댓글의 작성자아이디 === 로그인한 사용자아이디
            	$('<button>').addClass('delRepBtn').attr('data-no',rep.repNo).html('삭제').appendTo($div1); //<button>삭제</button>
				}
            	$('<div>').html(rep.repContent).appendTo($repDiv); // <div>댓글내용</div>

            }
        })
        .fail(function (jqXHR, status, error) {
            console.log('요청 실패 : ');
        });
	}
	
	$('#repDiv').on('click', '.delRepBtn',function(){
		//삭제요청전송
		$.ajax({
	        url: '${pageContext.request.contextPath}/reply/del.do',//요청주소
	        method: 'POST', //요청방식(GET,POST,PUT,DELETE,.....)
	        data : {repNo : $(this).attr('data-no') }, // 'repNo=삭제할댓글번호'
	        dataType: 'json' //요청응답으로 받을 데이터 타입(text,html,json,xml,...)

	    })
	        .done(function (data, status, jqXHR) {
	            console.log('요청성공 : ');
	            console.log(data);
	            // 1개의 레코드가 추가(insert)된 경우 성공했다는 메시지 출력
	            if(data.result == 1){
	            	refreshReplyList();
	                alert('댓글이 삭제되었습니다.');
	            }else{
	            	alert('댓글을 삭제하지 못했습니다.');
	            }
	        })
	        .fail(function (jqXHR, status, error) {
	            console.log('요청 실패 : ');
	            alert('댓글을 삭제하지 못했습니다.');
	        });
	});
	
	refreshReplyList();
	
	$('#repAddBtn').on('click', function() {		
	$.ajax({
        url: '${pageContext.request.contextPath}/reply/add.do',//요청주소
        method: 'POST', //요청방식(GET,POST,PUT,DELETE,.....)
        //요청시 함께 보낼 데이터 (파라미터)
        //(1) "x=1&y=2"와 같은 형식의 파라미터 문자열 직접 생성하여 설정하는방식
        //data : 'repBbsNo='+ $('[name="repBbsNo"]').val() +'&repContent='+$('[name="repContent"]').val(), //요청시 함께 보낼 데이터(파라미터)
        //(2) 파라미터들을 {파라미터명:파라미터값, 파라미터명:파라미터값} 객체로 설정하는 방식
        //data : {repBbsNo : $('[name="repBbsNo"]').val(), &repContent : $('[name="repContent"]').val()},
        //(3)폼 또는 입력엘리먼트들을 찾아서 serialize() 를 실행하면
        //입력엘리먼트들을 파라미터 문자열로 자동 생성
        data : $('#repForm').serialize(),
        dataType: 'json' //요청응답으로 받을 데이터 타입(text,html,json,xml,...)

    })
        .done(function (data, status, jqXHR) {
            console.log('요청성공 : ');
            console.log(data);
            // 1개의 레코드가 추가(insert)된 경우 성공했다는 메시지 출력
            if(data.result == 1){
            	refreshReplyList();
                alert('댓글이 저장되었습니다.');
            }else{
            	alert('댓글이 저장하지 못했습니다.');
            }
        })
        .fail(function (jqXHR, status, error) {
            console.log('요청 실패 : ');
            alert('댓글이 저장하지 못했습니다.');
        });
	});
	</script>

</body>
</html>






