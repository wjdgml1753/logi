package kr.co.seoulit.logistics.sys.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class ControllerExceptionAspect {

    @Around("execution(* kr..controller.*.*(..))")
    public Object controllerExceptionHandler(ProceedingJoinPoint proceedingJoinPoint) {
        try {
            return proceedingJoinPoint.proceed();
        } catch(Throwable e) {
             System.out.println("익셉션에이오피가 정상작동 했습니다!"+e.getMessage());
            throw new RuntimeException(e.getMessage());
        }
    }

}
