package ragna.reactive.sample.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.repository.CrudRepository;
import ragna.reactive.sample.model.Quote;

import java.util.List;

public interface QuoteMongoBlockingRepository extends CrudRepository<Quote, String> {

    @Query("{ id: { $exists: true } }")
    List<Quote> retrieveAllQuotesPaged(final Pageable page);
}
