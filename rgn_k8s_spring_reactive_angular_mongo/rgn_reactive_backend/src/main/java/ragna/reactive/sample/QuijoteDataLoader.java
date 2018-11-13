package ragna.reactive.sample;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import ragna.reactive.sample.model.Quote;
import ragna.reactive.sample.repository.QuoteMongoReactiveRepository;
import reactor.core.publisher.Flux;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.function.LongSupplier;

@Slf4j
@Component
public class QuijoteDataLoader implements CommandLineRunner {

    private QuoteMongoReactiveRepository quoteMongoReactiveRepository;

    public QuijoteDataLoader(QuoteMongoReactiveRepository quoteMongoReactiveRepository) {
        this.quoteMongoReactiveRepository = quoteMongoReactiveRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        if (quoteMongoReactiveRepository.count().block() == 0L) {

            final LongSupplier longSupplier = new LongSupplier() {
                Long l = 0L;
                @Override
                public long getAsLong() {
                    return l++;
                }
            };

            BufferedReader bufferedReader = new BufferedReader(
                new InputStreamReader(getClass().getClassLoader().getResourceAsStream("pg2000.txt")));

            Flux.fromStream(
                    bufferedReader.lines()
                            .filter(line -> !line.trim().isEmpty())
                            .map(line -> quoteMongoReactiveRepository.save(
                                    new Quote(String.valueOf(longSupplier.getAsLong()), "El Quijote", line)))
            ).subscribe(quoteMono -> log.info("New quote loaded: {}", quoteMono.block()));

            log.info("Repository contains now {} entries.", quoteMongoReactiveRepository.count().block());
        }
    }
}
