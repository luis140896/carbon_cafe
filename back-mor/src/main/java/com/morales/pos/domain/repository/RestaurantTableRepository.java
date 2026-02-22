package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.RestaurantTable;
import com.morales.pos.domain.enums.TableStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RestaurantTableRepository extends JpaRepository<RestaurantTable, Long> {

    List<RestaurantTable> findByIsActiveTrueOrderByDisplayOrderAscTableNumberAsc();

    List<RestaurantTable> findByStatusAndIsActiveTrueOrderByTableNumberAsc(TableStatus status);

    List<RestaurantTable> findByZoneAndIsActiveTrueOrderByTableNumberAsc(String zone);

    Optional<RestaurantTable> findByTableNumber(Integer tableNumber);

    boolean existsByTableNumber(Integer tableNumber);

    @Query("SELECT MAX(t.tableNumber) FROM RestaurantTable t")
    Integer findMaxTableNumber();

    @Query("SELECT t FROM RestaurantTable t WHERE t.isActive = true AND t.zone = :zone ORDER BY t.displayOrder, t.tableNumber")
    List<RestaurantTable> findActiveByZone(@Param("zone") String zone);

    long countByStatusAndIsActiveTrue(TableStatus status);
}
