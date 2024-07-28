package com.alcashop.inventory_service;

import com.alcashop.inventory_service.model.Inventory;
import com.alcashop.inventory_service.repository.InventoryRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class InventoryServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(InventoryServiceApplication.class, args);
    }

    @Bean
    public CommandLineRunner loadData(InventoryRepository inventoryRepository){
        return args -> {
            Inventory inventory1 = new Inventory();
            inventory1.setSkuCode("table");
            inventory1.setQuantity(30);

            Inventory inventory2 = new Inventory();
            inventory2.setSkuCode("charger");
            inventory2.setQuantity(0);

            Inventory inventory = new Inventory();
            inventory.setSkuCode("battery");
            inventory.setQuantity(3);

            inventoryRepository.save(inventory);
            inventoryRepository.save(inventory1);
        };
    }
}
