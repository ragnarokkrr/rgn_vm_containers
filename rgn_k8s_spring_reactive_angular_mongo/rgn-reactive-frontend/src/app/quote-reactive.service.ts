import { Injectable } from '@angular/core';

import { Quote } from './model/quote';
// https://stackoverflow.com/questions/52352532/eventsource-not-working-in-angular-6-due-to-module-http-and-https
// import * as EventSource from 'eventsource';
import { EventSourcePolyfill } from 'ng-event-source';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class QuoteReactiveService {

  quotes: Quote[] = [];
  url: string = 'http://localhost:8080/quotes-reactive';
  urlPaged: string = 'http://localhost:8080/quotes-reactive-paged';

  constructor() { }

  getQuoteStream(page?: number, size?: number): Observable<Array<Quote>> {
    this.quotes = [];
    return Observable.create((observer) => {
      let url = this.url;
      if (page != null) {
        url = `${this.urlPaged}?page=${page}&size=${size}`;
      }
      let eventSource = new EventSourcePolyfill(url, {heartbeatTimeout: 1000, connectionTimeout: 1000});
      eventSource.onmessage = (event) => {
        console.debug('Received event: ', event);
        let json = JSON.parse(event.data);
        this.quotes.push(new Quote(json['id'], json['book'], json['content']));
        observer.next(this.quotes);
      };

      eventSource.onerror = (error) => {
        // readyState === 0 (closed) means the remote source closed the connection,
        // so we can safely treat it as a normal situation. Another way of detecting the end of the stream
        // is to insert a special element in the stream of events, which the client can identify as the last one.        
        if (eventSource.readyState === 0) {
          console.log('The stream has been closed by the server.');
          eventSource.close();
          observer.complete()
        } else {
          observer.error('EventSource error: ' + error);
        }
      };

    });
  }
}
