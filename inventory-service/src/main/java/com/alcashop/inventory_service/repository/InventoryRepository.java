package com.alcashop.inventory_service.repository;

import com.alcashop.inventory_service.model.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    //type of objet we want to store, and type of the primiry key
   // Optional<Inventory> findBySkuCodeIn();
   List<Inventory> findBySkuCodeIn(List<String> skuCodes); // Notez que nous utilisons List<String>

}
