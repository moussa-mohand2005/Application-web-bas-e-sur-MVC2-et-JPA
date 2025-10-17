package net.moussa.jpa.startup;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

@Singleton
@Startup
public class DataLoader {

    @PostConstruct
    public void loadData() {
    }
}

