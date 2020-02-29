FROM vapor/swift:5.2-xenial

WORKDIR /package
COPY . ./
RUN swift package resolve
RUN swift package clean
CMD ["swift", "test", "--enable-test-discovery"]
