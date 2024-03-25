package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.common.util.QueryDslSupport;
import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.entity.QCategoryDetail;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyThumbnailResponse;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.entity.QPolicy;
import com.e102.simcheonge_server.domain.policy_category_detail.entity.QPolicyCategoryDetail;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQuery;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Lob;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import static com.e102.simcheonge_server.domain.policy.entity.QPolicy.policy;

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
        BooleanBuilder whereBuilder = new BooleanBuilder();

        for (int i = 0; i < detailList.size(); i++) {
            String codeParam = detailList.get(i).getCode();
            Integer numberParam = detailList.get(i).getNumber();

            BooleanBuilder andBuilder = new BooleanBuilder();
            andBuilder.and(QPolicyCategoryDetail.policyCategoryDetail.code.eq(codeParam))
                    .and(QPolicyCategoryDetail.policyCategoryDetail.number.eq(numberParam));

            whereBuilder.or(andBuilder);
        }


        JPAQuery<Integer> countQuery = queryFactory
                .select(QPolicyCategoryDetail.policyCategoryDetail.policyId)
                .from(QPolicyCategoryDetail.policyCategoryDetail)
                .leftJoin(QCategoryDetail.categoryDetail)
                .on(QPolicyCategoryDetail.policyCategoryDetail.code.eq(QCategoryDetail.categoryDetail.code)
                        .and(QPolicyCategoryDetail.policyCategoryDetail.number.eq(QCategoryDetail.categoryDetail.number)))
                .where(whereBuilder)
                .groupBy(QPolicyCategoryDetail.policyCategoryDetail.policyId,
                        QPolicyCategoryDetail.policyCategoryDetail.code)
                .having(QPolicyCategoryDetail.policyCategoryDetail.policyId.count()
                        .eq((long) detailList.stream()
                                .filter(d -> d.getCode().equals(QPolicyCategoryDetail.policyCategoryDetail.code))
                                .count())).distinct();

        JPAQuery<Tuple> sample = queryFactory
                .select(QPolicyCategoryDetail.policyCategoryDetail.policyId,
                        QPolicyCategoryDetail.policyCategoryDetail.policyId.count(),
                        QPolicyCategoryDetail.policyCategoryDetail.code)
                .from(QPolicyCategoryDetail.policyCategoryDetail)
                .leftJoin(QCategoryDetail.categoryDetail)
                .on(QPolicyCategoryDetail.policyCategoryDetail.code.eq(QCategoryDetail.categoryDetail.code)
                        .and(QPolicyCategoryDetail.policyCategoryDetail.number.eq(QCategoryDetail.categoryDetail.number)))
                .groupBy(QPolicyCategoryDetail.policyCategoryDetail.policyId,
                        QPolicyCategoryDetail.policyCategoryDetail.code).distinct();

        String sql = countQuery.toString();
        log.info("sql={}", sql);

        List<Integer> policyList = countQuery.fetch();
        List<Tuple> sampleList = sample.fetch();

        for (Tuple tuple : sampleList) {
            int policyId = tuple.get(QPolicyCategoryDetail.policyCategoryDetail.policyId);
            String code = tuple.get(QPolicyCategoryDetail.policyCategoryDetail.code);
            Long categoryCount = tuple.get(QPolicyCategoryDetail.policyCategoryDetail.policyId.count());
            Long checkCount = detailList.stream()
                    .filter(d -> d.getCode().equals(tuple.get(QPolicyCategoryDetail.policyCategoryDetail.code)))
                    .count();
            log.info("PolicyId: {}, Code: {}, CategoryCount: {}", policyId, code, categoryCount);
            log.info("categoryCount={}, checkCount={}", categoryCount, checkCount);

            if(policyId==0){
                log.info("policyId==0 ==> code={}",code);
                log.info("categoryCount={}, checkCount={}", categoryCount, checkCount);
            }
            if (Objects.equals(categoryCount, checkCount)) {
                if(checkArray[policyId]==0) checkArray[policyId] = 1;
            } else checkArray[policyId] = -1;
            if(policyId==182){
                log.info("checkArray[policyId]={}",checkArray[policyId]);
            }
        }
        List<Integer> resp=new ArrayList<>();
        for (int i = 0; i < 500; i++) {
            if (checkArray[i] == 1) {
                resp.add(i);
            }
        }

//        List<Tuple> excludedTuples = JPAExpressions
//                .select(QPolicyCategoryDetail.policyCategoryDetail.policyId,
//                        QPolicyCategoryDetail.policyCategoryDetail.code,
//                        QPolicyCategoryDetail.policyCategoryDetail.number)
//                .from(QPolicyCategoryDetail.policyCategoryDetail)
//                .leftJoin(QCategoryDetail.categoryDetail)
//                .on(QPolicyCategoryDetail.policyCategoryDetail.code.eq(QCategoryDetail.categoryDetail.code)
//                        .and(QPolicyCategoryDetail.policyCategoryDetail.number.eq(QCategoryDetail.categoryDetail.number)))
//                .where(whereBuilder)
//                .fetch();
        BooleanBuilder notInBuilder = new BooleanBuilder();

        for (int i = 0; i < detailList.size(); i++) {
            String code = detailList.get(i).getCode();
            Integer number = detailList.get(i).getNumber();

            notInBuilder.and(
                    QPolicyCategoryDetail.policyCategoryDetail.code.ne(code)
                            .or(QPolicyCategoryDetail.policyCategoryDetail.number.ne(number))
            );
        }

        String notInBuilderString=notInBuilder.toString();
        log.info("notInBuilderString={}",notInBuilderString);

        List<Integer> excludedPolicyIds = queryFactory
                .select(QPolicyCategoryDetail.policyCategoryDetail.policyId)
                .from(QPolicyCategoryDetail.policyCategoryDetail)
                .where(notInBuilder)
                .distinct()
                .fetch();

        resp.removeAll(excludedPolicyIds);

        return resp;
    }

}
