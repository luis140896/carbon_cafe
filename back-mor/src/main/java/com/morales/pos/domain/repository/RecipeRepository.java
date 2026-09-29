package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    Optional<Recipe> findByProductId(Long productId);

    @Query("SELECT DISTINCT r FROM Recipe r " +
           "LEFT JOIN FETCH r.items i " +
           "LEFT JOIN FETCH i.ingredient " +
           "JOIN FETCH r.product " +
           "WHERE r.product.id = :productId")
    Optional<Recipe> findByProductIdWithItems(@Param("productId") Long productId);

    @Query("SELECT r FROM Recipe r JOIN FETCH r.product p ORDER BY LOWER(p.name)")
    List<Recipe> findAllWithProduct();

    boolean existsByProductId(Long productId);
}
