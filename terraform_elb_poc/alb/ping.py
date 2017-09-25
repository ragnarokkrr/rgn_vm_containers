import sched, time, requests
s = sched.scheduler(time.time, time.sleep)

def do_something(sc):
    print "test url"
    # do your stuff

    response = requests.get('http://terraform.splunkalbpoc.alb.scratch.oneplatform.build/')
    print (response.status_code)
    print (response.content)

    s.enter(5, 1, do_something, (sc,))

s.enter(5, 1, do_something, (s,))
s.run()
