# 📊 Phân Tích Thị Trường Việc Làm Data Analyst (SQL Project)

## 1. Giới thiệu

Dự án này sử dụng **SQL** để phân tích dữ liệu **job postings** nhằm tìm hiểu thị trường việc làm cho vị trí **Data Analyst**.

Mục tiêu của dự án là trả lời các câu hỏi quan trọng:

- Những **công việc Data Analyst có mức lương cao nhất** là gì?
- Những **kỹ năng cần thiết cho các công việc lương cao** là gì?
- **Kỹ năng nào được yêu cầu nhiều nhất** trong thị trường?
- **Kỹ năng nào có mức lương trung bình cao nhất**?
- **Kỹ năng nào vừa có nhu cầu cao vừa có mức lương tốt**?

Thông qua phân tích này, người học Data Analyst có thể hiểu rõ **nên học kỹ năng nào để tối đa cơ hội việc làm và mức lương**.

---

# 2. Bối cảnh (Background)

Nhu cầu tuyển dụng **Data Analyst** đang tăng mạnh trong nhiều ngành khác nhau. Tuy nhiên, không phải kỹ năng nào cũng có giá trị như nhau trên thị trường lao động.

Dự án này sử dụng dữ liệu job postings để phân tích:

1. Công việc Data Analyst có **mức lương cao nhất**
2. **Kỹ năng yêu cầu** cho những công việc đó
3. **Những kỹ năng phổ biến nhất**
4. **Kỹ năng liên quan đến mức lương cao**
5. **Kỹ năng tối ưu (vừa nhiều nhu cầu vừa lương cao)**

Các bảng dữ liệu được sử dụng:

- `job_postings_fact`
- `company_dim`
- `skills_job_dim`
- `skills_dim`

---

# 3. Công cụ sử dụng

### SQL

SQL được sử dụng để truy vấn và phân tích dữ liệu.

Các kỹ thuật SQL sử dụng trong project:

- `INNER JOIN`
- `LEFT JOIN`
- `CTE (Common Table Expressions)`
- `COUNT()`
- `AVG()`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`

---

# 4. Phân tích dữ liệu

## 4.1 Các công việc Data Analyst có lương cao nhất

Query này tìm **10 công việc Data Analyst có mức lương cao nhất (remote)**.

```sql
select job_id,
    job_title_short,
    job_title,
    name as company_name,
    job_location,
    job_schedule_type,
    job_country,
    salary_year_avg
from job_postings_fact
    left join company_dim using (company_id)
where job_title_short = 'Data Analyst'
    and salary_year_avg is not null
    and job_location = 'Anywhere'
order by salary_year_avg DESC
limit 10;
```

### Mục đích

Xác định **các công ty trả lương cao nhất cho vị trí Data Analyst làm việc từ xa**.

---

# 4.2 Kỹ năng cần có cho các công việc lương cao

Query này tìm **các kỹ năng yêu cầu cho 10 công việc lương cao nhất**.

```sql
with top_paying_job as (
    select job_id,
        job_title,
        name as company_name,
        salary_year_avg
    from job_postings_fact
        left join company_dim using (company_id)
    where job_title_short = 'Data Analyst'
        and salary_year_avg is not null
        and job_location = 'Anywhere'
    order by salary_year_avg DESC
    limit 10
)

select top_paying_job.*,
    skills as skill_name
from top_paying_job
    inner join skills_job_dim using(job_id)
    inner join skills_dim using (skill_id)
order by salary_year_avg DESC;
```

### Mục đích

Xác định **những kỹ năng quan trọng để đạt được các công việc có mức lương cao**.

---

# 4.3 Những kỹ năng được yêu cầu nhiều nhất

Query này tìm **5 kỹ năng phổ biến nhất trong các job Data Analyst**.

```sql
select skills,
    count(skills) as count_skills
from job_postings_fact
    inner join skills_job_dim using(job_id)
    inner join skills_dim using (skill_id)
where job_postings_fact.job_title_short = 'Data Analyst'
group by skills
order by count_skills desc
limit 5;
```

### Mục đích

Xác định **kỹ năng nào xuất hiện nhiều nhất trong các tin tuyển dụng**.

---

# 4.4 Kỹ năng có mức lương cao nhất

Query này tìm **các kỹ năng có mức lương trung bình cao nhất**.

```sql
select skills as skills_name,
    round(avg(salary_year_avg), 2) as avg_salary,
    count(skills) as job_count
from job_postings_fact
    inner join skills_job_dim using(job_id)
    inner join skills_dim using (skill_id)
where job_title_short = 'Data Analyst'
    and salary_year_avg is not null
group by skills_name
order by avg_salary desc
limit 25;
```

### Mục đích

Xác định **kỹ năng nào giúp tăng mức lương cho Data Analyst**.

---

# 4.5 Kỹ năng tối ưu (Nhu cầu cao + Lương cao)

Phân tích này kết hợp **nhu cầu kỹ năng và mức lương trung bình**.

```sql
with skills_demand as (
    select skill_id,
        skills,
        count(skills) as count_skills
    from job_postings_fact
        inner join skills_job_dim using(job_id)
        inner join skills_dim using (skill_id)
    where job_postings_fact.job_title_short = 'Data Analyst'
        and salary_year_avg is not null
        and job_work_from_home = True
    group by skill_id,
        skills
),

average_salary as (
    select skill_id,
        skills as skills_name,
        round(avg(salary_year_avg), 2) as avg_salary
    from job_postings_fact
        inner join skills_job_dim using(job_id)
        inner join skills_dim using (skill_id)
    where job_title_short = 'Data Analyst'
        and salary_year_avg is not null
    group by skill_id,
        skills
)

select skills_demand.skill_id,
    skills_demand.skills,
    count_skills,
    avg_salary
from skills_demand
    INNER JOIN average_salary using(skill_id)
order by count_skills desc,
    avg_salary desc;
```

### Mục đích

Tìm **những kỹ năng đáng học nhất** vì:

- Có **nhu cầu cao**
- Có **mức lương tốt**

---

# 5. Insight rút ra từ dữ liệu

Từ phân tích dữ liệu, có thể rút ra một số insight quan trọng:

### 1. Nhiều công việc lương cao cho phép làm remote
Các vị trí Data Analyst lương cao thường cho phép **làm việc từ xa**.

### 2. SQL là kỹ năng cốt lõi
SQL xuất hiện trong rất nhiều job postings → đây là **kỹ năng bắt buộc đối với Data Analyst**.

### 3. Kỹ năng kỹ thuật giúp tăng lương
Các kỹ năng như:

- SQL
- Python
- Công cụ visualization
- Công nghệ cloud

thường liên quan đến **mức lương cao hơn**.

### 4. Không phải kỹ năng phổ biến nào cũng có lương cao
Một số kỹ năng xuất hiện rất nhiều nhưng **không phải lúc nào cũng đi kèm mức lương cao**.

### 5. Kỹ năng tốt nhất là kỹ năng vừa có nhu cầu cao vừa có lương cao
Đây là **những kỹ năng nên ưu tiên học nếu muốn trở thành Data Analyst**.

---

# 6. Những gì tôi học được từ dự án

Thông qua dự án này, tôi đã cải thiện các kỹ năng:

- Viết **SQL query phức tạp**
- Sử dụng **JOIN để kết hợp nhiều bảng dữ liệu**
- Sử dụng **CTE để tổ chức query rõ ràng**
- Phân tích dữ liệu bằng **COUNT và AVG**
- Chuyển đổi dữ liệu thành **insight có ý nghĩa**

Ngoài ra, dự án giúp tôi hiểu rõ hơn về:

- **Thị trường việc làm Data Analyst**
- **Những kỹ năng cần thiết để phát triển sự nghiệp**

---

⭐ Nếu bạn quan tâm đến phân tích dữ liệu bằng SQL, hãy thử chạy các query trong project để khám phá thêm về thị trường Data Analyst.
