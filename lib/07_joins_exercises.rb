# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    SELECT
      title
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Harrison Ford'
  SQL
end

# i think i prefer without table name when referring to specific column, but idk if it's just up to personal preference or if listing table name is actually better
def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
    SELECT
      title
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      name = 'Harrison Ford' AND
      ord > 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    SELECT
      title, name
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      yr = 1962 AND
      ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    SELECT
      yr, COUNT(title)
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      name = 'John Travolta'
    GROUP BY
      yr
    HAVING
      COUNT(title) >= 2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    SELECT
      title, name
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      ord = 1 AND
      movie_id IN
      (
      SELECT
        movie_id
      FROM
        movies
      JOIN
        castings ON movies.id = castings.movie_id
      JOIN
        actors ON castings.actor_id = actors.id
      WHERE
        actor_id = (
                   SELECT
                     id
                   FROM
                     actors
                   WHERE
                     name = 'Julie Andrews'
                   )
      )
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT
      DISTINCT name
    FROM
      castings
    JOIN
      movies ON castings.movie_id = movies.id
    JOIN
      actors ON castings.actor_id = actors.id
    GROUP BY
      name
    HAVING
      COUNT(
           SELECT


        ) >= 15
    ORDER BY
      name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SQL
end

def test_prolific_actors
  execute(<<-SQL)
    SELECT
      DISTINCT name
    FROM
      castings
    JOIN
      movies ON castings.movie_id = movies.id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      COUNT(
        #in movie
        SELECT
          COUNT(movie_id)
        FROM
          castings
        JOIN
          movies ON castings.movie_id = movies.id
        JOIN
          actors ON castings.actor_id = actors.id
        WHERE
          actor_id = 592 AND
          ord = 1
        AND
        #order = 1?
        ) >= 15
    ORDER BY
      name
  SQL
end

# i keep getting i think a count of all films the actor has been in, not only the ones where they star...apply technique from julie andrews to get list of all movies they star in and then count that subquery?
def test2_prol
  execute(<<-SQL)
    SELECT
      name, COUNT(actors.id = actor_id)
    FROM
      castings
    JOIN
      movies ON castings.movie_id = movies.id
    JOIN
      actors ON castings.actor_id = actors.id
    GROUP BY
      name
    HAVING
      COUNT(actors.id = actor_id) >= 15
  SQL
end

# trying with 1 actor first
# this works but how do i generalize it so that it can be used on all actors, not just a specific one i name?
def test3_prol
  execute(<<-SQL)
    SELECT
      title, name
    FROM
      castings
    JOIN
      movies ON castings.movie_id = movies.id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      name = 'Tom Hanks' AND
      ord = 1
  SQL
end

def show_castings
  execute(<<-SQL)
    SELECT
      *
    FROM
      castings
  SQL
end
