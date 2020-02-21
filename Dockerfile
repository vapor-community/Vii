FROM vapor/swift:5.1-xenial

WORKDIR /package
COPY . ./
RUN swift package resolve
RUN swift package clean
RUN apt-get install openssl libssl-dev
CMD ["swift", "test", "--enable-test-discovery"]