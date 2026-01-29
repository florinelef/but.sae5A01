package fr.but3.sae_web.models;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

public interface DocumentsRepository extends CrudRepository<Documents, Integer>{
    List<Documents> findByLoginAndIdSlot(String login, Integer id_slot);
}
