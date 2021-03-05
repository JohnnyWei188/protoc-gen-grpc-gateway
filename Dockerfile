FROM golang:1.14.10-alpine3.12

RUN apk update && apk add --no-cache curl bash tzdata protobuf \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone \
&& mkdir src/tools && cd src/tools  \
&& echo -e "// +build tools \n package tools \n\n import (\n _ \"github.com/envoyproxy/protoc-gen-validate\" \n _ \"github.com/golang/protobuf/protoc-gen-go\" \n _ \"github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway\" \n _ \"github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger\" \n )" >> tools.go  \ 
&& go env -w GOPROXY="https://goproxy.cn" \
&& go fmt tools.go && go mod init && go mod tidy \
&& go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
github.com/golang/protobuf/protoc-gen-go \
github.com/envoyproxy/protoc-gen-validate \ 
&& cd .. && rm -rf tools 

CMD ["/bin/bash"]
