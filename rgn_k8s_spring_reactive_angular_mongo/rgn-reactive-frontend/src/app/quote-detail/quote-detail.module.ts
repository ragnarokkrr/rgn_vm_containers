import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule }      from '@angular/core';

import { QuoteDetailComponent } from './quote-detail.component';
import { QuoteReactiveService } from '../quote-reactive.service';
import { QuoteBlockingService } from '../quote-blocking.service';

@NgModule({
    imports: [
        FormsModule,
        BrowserModule
    ],
    exports: [
      QuoteDetailComponent
    ],
    declarations: [ 
      QuoteDetailComponent
    ],
    providers: [
      // QuoteReactiveService,
      // QuoteBlockingService
    ]
  })
export class QuoteDetailModule { }