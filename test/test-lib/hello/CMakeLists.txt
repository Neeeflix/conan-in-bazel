project("hello-lib")

add_library(${PROJECT_NAME} STATIC
    "src/hello.cpp"
)

target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    "include"
)