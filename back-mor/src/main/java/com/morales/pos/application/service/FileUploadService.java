package com.morales.pos.application.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
public class FileUploadService {

    @Value("${app.upload.path:./uploads}")
    private String uploadPath;

    @Value("${app.upload.allowed-extensions:jpg,jpeg,png,gif,webp}")
    private String allowedExtensions;

    private Path uploadDir;

    @PostConstruct
    public void init() {
        uploadDir = Paths.get(uploadPath).toAbsolutePath().normalize();
        try {
            Files.createDirectories(uploadDir);
            log.info("Upload directory: {}", uploadDir);
        } catch (IOException e) {
            throw new RuntimeException("No se pudo crear el directorio de uploads", e);
        }
    }

    public String uploadFile(MultipartFile file, String subfolder) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("El archivo está vacío");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = getExtension(originalFilename);

        List<String> allowed = Arrays.asList(allowedExtensions.split(","));
        if (!allowed.contains(extension.toLowerCase())) {
            throw new IllegalArgumentException("Extensión no permitida: " + extension + ". Permitidas: " + allowedExtensions);
        }

        long maxSize = 5 * 1024 * 1024; // 5MB
        if (file.getSize() > maxSize) {
            throw new IllegalArgumentException("El archivo excede el tamaño máximo de 5MB");
        }

        Path targetDir = uploadDir.resolve(subfolder);
        Files.createDirectories(targetDir);

        String newFilename = UUID.randomUUID().toString() + "." + extension;
        Path targetPath = targetDir.resolve(newFilename);

        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        log.info("Archivo subido: {}", targetPath);

        return "/uploads/" + subfolder + "/" + newFilename;
    }

    public void deleteFile(String filePath) {
        if (filePath == null || !filePath.startsWith("/uploads/")) return;
        try {
            String relativePath = filePath.substring("/uploads/".length());
            Path path = uploadDir.resolve(relativePath);
            Files.deleteIfExists(path);
            log.info("Archivo eliminado: {}", path);
        } catch (IOException e) {
            log.warn("No se pudo eliminar archivo: {}", filePath, e);
        }
    }

    private String getExtension(String filename) {
        if (filename == null || !filename.contains(".")) return "";
        return filename.substring(filename.lastIndexOf('.') + 1);
    }
}
