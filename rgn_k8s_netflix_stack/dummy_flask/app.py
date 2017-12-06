from flask import Flask
import os

app = Flask(__name__)

HELLO = 'DEFAULT'


@app.route('/')
def hello():
    global HELLO
    HELLO = os.environ['HELLO']
    return 'Hello Flask (%s)!!! ' % HELLO


if __name__ == '__main__':
    app.debug = True
    app.run(host="0.0.0.0", port="6000", debug=False)
