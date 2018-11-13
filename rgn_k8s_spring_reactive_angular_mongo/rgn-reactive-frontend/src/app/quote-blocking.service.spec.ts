import { TestBed } from '@angular/core/testing';

import { QuoteBlockingService } from './quote-blocking.service';

describe('QuoteBlockingService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: QuoteBlockingService = TestBed.get(QuoteBlockingService);
    expect(service).toBeTruthy();
  });
});
