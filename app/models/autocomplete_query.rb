class AutocompleteQuery
  attr_reader :options

  DEFAULT_RESULTS_LIMIT = 1000

  def initialize options = {}
    @options = options
  end

  def self.search options = {}
    new(options).search
  end

  def search
    {
      "meta" => meta_data,
      "results" => results
    }
  end

  private

  def results
    ActiveIngredient.
      name_starts_with(query).
      limit(results_limit).
      offset(skip_count).
      order(sort_options)
  end

  def meta_data
    {
      "results" => {
        "limit" => results_limit,
        "total" => ActiveIngredient.count,
        "skip"  => skip_count,
        "count" => results.count,
        "sort"  => sort_options
      }
    }
  end

  def query
    options.fetch(:query, nil)
  end

  def results_limit
    options.fetch(:limit, DEFAULT_RESULTS_LIMIT)
  end

  def skip_count
    options.fetch(:skip, 0)
  end

  def sort_options
    "#{options.fetch(:sort, "name")} #{options.fetch(:sort_dir, "asc")}"
  end
end
