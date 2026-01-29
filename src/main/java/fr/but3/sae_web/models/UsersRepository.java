package fr.but3.sae_web.models;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsersRepository extends CrudRepository<Users, String> {
    Users findByLoginAndPassword(String login, String password);
    Users findByLogin(String login);
    List<Users> findAllByLoginIn(List<String> logins);
}
