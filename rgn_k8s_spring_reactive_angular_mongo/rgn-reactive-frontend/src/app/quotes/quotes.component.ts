import { Component, OnInit } from '@angular/core';

import { Quote } from '../model/quote';
import { QuoteReactiveService } from '../quote-reactive.service';
import { QuoteBlockingService } from '../quote-blocking.service';

import { Observable } from 'rxjs';

@Component({
  selector: 'app-quotes',
  templateUrl: './quotes.component.html',
  styleUrls: ['./quotes.component.css']
})
export class QuotesComponent implements OnInit {
  quotes: Observable<Quote[]>;
  selectedQuote: Quote;
  mode: String;
  pagination: boolean;
  page: number;
  size: number;

  constructor(private quoteReactiveService: QuoteReactiveService,
              private quoteBlockingService: QuoteBlockingService) { 
    this.mode = "reactive";
    this.pagination = true;
    this.page = 0;
    this.size = 50;
  }

  ngOnInit(): void {
  }

  requestQuoteStream(): void {
    if (this.pagination === true) {
      this.quotes = this.quoteReactiveService.getQuoteStream(this.page, this.size);
    } else {
      this.quotes = this.quoteReactiveService.getQuoteStream();
    }
  }

  requestQuoteBlocking(): void {
    if (this.pagination === true) {
      this.quotes = this.quoteBlockingService.getQuotes(this.page, this.size);
    } else {
      this.quotes = this.quoteBlockingService.getQuotes();
    }
  }

  onSelect(quote: Quote): void {
    this.selectedQuote = quote;
  }
}
