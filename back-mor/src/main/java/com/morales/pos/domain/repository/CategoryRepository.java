package com.morales.pos.domain.repository;

import com.morales.pos.domain.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    @Query("SELECT c FROM Category c WHERE c.isActive = true ORDER BY c.displayOrder, c.name")
    List<Category> findAllActiveOrdered();

    @Query("SELECT c FROM Category c WHERE c.parent IS NULL AND c.isActive = true ORDER BY c.displayOrder")
    List<Category> findRootCategories();

    @Query("SELECT c FROM Category c WHERE c.parent.id = :parentId AND c.isActive = true ORDER BY c.displayOrder")
    List<Category> findByParentId(Long parentId);

    boolean existsByName(String name);

    List<Category> findAllByOrderByDisplayOrderAsc();

    List<Category> findByIsActiveTrueOrderByDisplayOrderAsc();

    List<Category> findByParentIsNullAndIsActiveTrueOrderByDisplayOrderAsc();

    @Query("SELECT MAX(c.displayOrder) FROM Category c")
    Integer findMaxDisplayOrder();
}
