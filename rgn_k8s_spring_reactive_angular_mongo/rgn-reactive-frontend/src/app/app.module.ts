import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';

import { QuoteBlockingService } from './quote-blocking.service';
import { QuoteReactiveService } from './quote-reactive.service';

import { QuotesModule } from './quotes/quotes.module'; 
import { QuoteDetailModule } from './quote-detail/quote-detail.module';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    QuotesModule,
    QuoteDetailModule
  ],
  providers: [
    QuoteBlockingService,
    QuoteReactiveService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
