import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule }      from '@angular/core';

import { QuotesComponent } from './quotes.component';
import { QuoteReactiveService } from '../quote-reactive.service';
import { QuoteBlockingService } from '../quote-blocking.service';
import { QuoteDetailModule } from '../quote-detail/quote-detail.module';

@NgModule({
    imports: [
      FormsModule,
      BrowserModule,
      QuoteDetailModule
    ],
    exports: [
      QuotesComponent
    ],
    declarations: [ 
      QuotesComponent 
    ],
    providers: [
      // QuoteReactiveService,
      // QuoteBlockingService
    ]
  })
export class QuotesModule { }