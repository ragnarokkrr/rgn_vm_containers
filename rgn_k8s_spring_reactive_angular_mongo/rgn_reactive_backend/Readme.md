## Commands

*docker*
```
	
$ docker-compose up

```



*startup*
```$bash
./mvnw spring-boot:run

```

*reactive api/SSE event stream**
```$bash
$ curl -H "Accept: text/event-stream" "http://localhost:8080/quotes-reactive-paged?page=0&size=50"
```

*blocking api*
```$bash
$ curl "http://localhost:8080/quotes-reactive-paged?page=0&size=50" | jq .
```

*angular commands*
```$bash
# generate service
$ ng generate service quote-reactive

$ ng generate service quote-blocking


#generate component
$ ng generate component quotes

$ ng generate component quote-detail

```


## Reference

* https://thepracticaldeveloper.com/2017/11/04/full-reactive-stack-with-spring-webflux-and-angularjs/#Continue_reading_the_Guide
* https://thepracticaldeveloper.com/full-reactive-stack/

