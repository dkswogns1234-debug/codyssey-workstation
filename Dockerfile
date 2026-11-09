# 베이스: 공식 nginx:alpine 이미지 (방식 A — 웹 서버 베이스 + 정적 콘텐츠/설정 교체)
FROM nginx:1.27-alpine

# 1) 메타데이터: 이미지 출처/용도 식별
LABEL org.opencontainers.image.title="codyssey-web" \
      org.opencontainers.image.description="Codyssey dev workstation custom nginx"

# 2) 환경변수: 실행 모드를 이미지 기본값으로 지정 (docker run -e 로 덮어쓰기 가능)
ENV APP_ENV=dev

# 3) 설정 교체: nginx 공식 이미지의 templates 기능(envsubst)으로 ENV를 설정에 주입
COPY app/conf/default.conf /etc/nginx/templates/default.conf.template

# 4) 정적 콘텐츠 교체
COPY app/site/ /usr/share/nginx/html/

# 5) 헬스체크: /health 응답으로 컨테이너 상태(healthy/unhealthy) 판단
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1/health || exit 1

EXPOSE 80
