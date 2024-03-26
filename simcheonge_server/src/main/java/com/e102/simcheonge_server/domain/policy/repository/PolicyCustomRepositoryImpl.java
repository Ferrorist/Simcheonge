package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.common.util.QueryDslSupport;
import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.category_detail.entity.QCategoryDetail;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy_category_detail.entity.QPolicyCategoryDetail;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.querydsl.sql.SQLQuery;
import com.querydsl.sql.SQLQueryFactory;
import com.querydsl.sql.SQLTemplates;
import com.querydsl.sql.SQLTemplates;
import com.querydsl.core.types.dsl.Expressions;
import jakarta.persistence.EntityManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static org.springframework.jdbc.core.JdbcOperationsExtensionsKt.query;

@Repository
@Slf4j
public class PolicyCustomRepositoryImpl extends QueryDslSupport implements PolicyCustomRepository {

    @Autowired
    public PolicyCustomRepositoryImpl(EntityManager entityManager) {
        super(Policy.class, entityManager);
    }

    private final int[] checkArray = new int[1001];

    @Override
    public List<Integer> searchPolicy(String keyword, ArrayList<CategoryDetailSearchRequest> detailList, ArrayList<String> categoryList) {
        JPAQuery<Integer> countQuery = queryFactory
                .select(QPolicyCategoryDetail.policyCategoryDetail.policyId)
                .from(QPolicyCategoryDetail.policyCategoryDetail)
                .distinct();

        List<Integer> policyList = countQuery.fetch();
        return policyList;
    }

    private void checkCodeCount(ArrayList<CategoryDetailSearchRequest> detailList, List<Tuple> sampleList) {
        //모든 categoryDetail에 대해서, code개수 같으면 1
        //한번이라도 개수 다르면 -1
        for (Tuple tuple : sampleList) {
            int policyId = tuple.get(QPolicyCategoryDetail.policyCategoryDetail.policyId);
            String code = tuple.get(QPolicyCategoryDetail.policyCategoryDetail.code);
            Long categoryCount = tuple.get(QPolicyCategoryDetail.policyCategoryDetail.policyId.count()) != null ?
                    tuple.get(QPolicyCategoryDetail.policyCategoryDetail.policyId.count()) : 0L;
            Long checkCount = detailList.stream()
                    .filter(d -> d.getCode().equals(tuple.get(QPolicyCategoryDetail.policyCategoryDetail.code)))
                    .count();
            log.info("PolicyId: {}, Code: {}, CategoryCount: {}", policyId, code, categoryCount);
            log.info("categoryCount={}, checkCount={}", categoryCount, checkCount);

            if(checkCount==0){
                if(checkArray[policyId]==0) checkArray[policyId] = 1;
            }
            else if (Objects.equals(categoryCount, checkCount)) {
                if(checkArray[policyId]==0) checkArray[policyId] = 1;
            } else checkArray[policyId] = -1;

        }
    }

    private static BooleanBuilder getBooleanBuilder(ArrayList<CategoryDetailSearchRequest> detailList) {
        BooleanBuilder whereBuilder = new BooleanBuilder();

        for (int i = 0; i < detailList.size(); i++) {
            String codeParam = detailList.get(i).getCode();
            Integer numberParam = detailList.get(i).getNumber();

            BooleanBuilder andBuilder = new BooleanBuilder();
            andBuilder.and(QPolicyCategoryDetail.policyCategoryDetail.code.eq(codeParam))
                    .and(QPolicyCategoryDetail.policyCategoryDetail.number.eq(numberParam));

            whereBuilder.or(andBuilder);
        }
        return whereBuilder;
    }
}
