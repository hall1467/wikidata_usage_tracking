CREATE TABLE monthly_item_quality(
	page_id              BIGINT,
	title                VARCHAR(255),
	rev_id               BIGINT,
	monthly_timestamp    BIGINT,
	prediction           VARCHAR(1),
	weighted_sum         DECIMAL 
);