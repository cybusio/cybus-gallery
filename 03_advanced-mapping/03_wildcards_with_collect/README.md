# Wildcards with Collect Rules - Advanced Aggregation

**Purpose**: Master wildcard-based data collection with collect rules for enterprise-scale analytics and cross-correlation  
**Focus**: Dynamic labels and multi-pattern aggregation  
**Prerequisites**: [Basic Wildcards](../01_basic_wildcards/) and [Array Mapping](../02_array/) concepts

## What You'll Learn

By the end of this section, you'll master:
- ✅ **Wildcard + Collect combination** for advanced data aggregation
- ✅ **Dynamic label strategies** to prevent data loss and enable analytics
- ✅ **Cross-correlation patterns** for enterprise-scale monitoring systems
- ✅ **Performance optimization** for large-scale topic aggregation

## The Challenge: Aggregating Dynamic Topic Data

You've learned wildcards for dynamic topics and arrays for different structures. Now combine both techniques to build powerful aggregation systems that can:

- **Collect data** from multiple wildcard-matching topics
- **Correlate information** across different topic patterns  
- **Build analytics** that span entire enterprise systems
- **Scale efficiently** with proper dynamic labeling

## Core Concepts

### What is a Collect Rule?
A **collect rule** creates a **key-value cache** that stores the last message from each subscribed topic. When any new message arrives, the transform has access to **all cached data** from all topics.

### Why Dynamic Labels Matter
**Dynamic labels** prevent data overwrite by creating unique cache keys for each wildcard match. Without them, messages from different sources overwrite each other, causing critical data loss.

### Two Essential Patterns
This section covers two fundamental patterns that solve different enterprise integration challenges.

## Tutorial Structure

This section contains **two focused tutorials** that teach you the essential patterns for wildcard-based collect operations:

### 📁 [01_single_topic_pattern/](./01_single_topic_pattern/) - Single Wildcard Pattern Aggregation
**Complexity**: ⭐⭐ Intermediate | **Focus**: Same topic structure, multiple instances

**What You'll Learn:**
- **Single wildcard collect**: Aggregate all topics matching `sensors/+room/temperature`
- **Cross-room analytics**: Calculate building-wide statistics and comparisons  
- **Dynamic labeling**: Prevent data loss with `room_{room}` patterns
- **Statistical processing**: Averages, min/max, outlier detection across topic sets

**Perfect For:**
- **Building automation**: All rooms follow same sensor pattern
- **Device fleets**: All devices use identical topic structure
- **Sensor networks**: Uniform data from multiple locations
- **Regional monitoring**: Same metrics across different regions

**Key Learning**: How to aggregate and analyze data from multiple topics that share the same structural pattern but have different identifiers.

---

### 📁 [02_array_of_topics_patterns/](./02_array_of_topics_patterns/) - Multi-Pattern Array Aggregation  
**Complexity**: ⭐⭐⭐ Advanced | **Focus**: Different topic structures, enterprise integration

**What You'll Learn:**
- **Array subscription complexity**: Handle completely different topic patterns in one service
- **Multi-domain integration**: Combine `factory/+line/status`, `maintenance/+equipment/next`, `quality/+batch/result`
- **Semantic labeling**: Use business-meaningful labels (`prod_{line}`, `maint_{equipment}`)
- **Cross-domain correlation**: Build enterprise analytics across different business systems

**Perfect For:**
- **Manufacturing execution systems**: Production + maintenance + quality integration
- **Enterprise IoT**: Different devices with incompatible topic structures  
- **Multi-system dashboards**: Combine data from various business domains
- **Legacy system integration**: Unify disparate enterprise data sources

**Key Learning**: How to handle enterprise scenarios where you need to collect and correlate data from completely different topic structures that cannot be unified with a single wildcard pattern.

## Quick Decision Guide

**🎯 Choose Single Wildcard Pattern ([01_single_topic_pattern/](./01_single_topic_pattern/)) When:**
- Topics share **identical structure**: `sensors/+room/temperature`, `devices/+id/status`
- Need **cross-instance analytics**: Compare all rooms, analyze device fleet health
- **Uniform data processing**: Same analysis across all matching topics
- **Building/IoT scenarios**: Sensor networks, device fleets, regional monitoring

**🚀 Choose Array Pattern ([02_array_of_topics_patterns/](./02_array_of_topics_patterns/)) When:**  
- Topics have **different structures**: `factory/+line/status` vs `maintenance/+equipment/next`
- **Enterprise integration**: Multi-system dashboards, MES implementation
- **Cross-domain correlation**: Production + quality + maintenance systems
- **Legacy modernization**: Unifying disparate business systems

## Learning Path

### 🎯 **Recommended Sequence**

1. **Start with [01_single_topic_pattern/](./01_single_topic_pattern/)** - Master the fundamentals
   - Learn dynamic labeling with uniform topic patterns
   - Understand collect rule behavior and cache management
   - Practice statistical processing across topic sets

2. **Advance to [02_array_of_topics_patterns/](./02_array_of_topics_patterns/)** - Handle enterprise complexity
   - Apply dynamic labeling to heterogeneous systems
   - Master multi-domain correlation techniques
   - Implement real-world enterprise integration patterns

### 💡 **Key Success Factors**

- **Dynamic Labeling Strategy**: Use semantic naming that reflects business context
- **JSONata Mastery**: Proper `$lookup($, 'key')` syntax for cached collect access
- **Performance Awareness**: Understand collect cache sizing and optimization
- **Business Logic**: Design labels that support your analytics requirements

Each tutorial includes complete working examples, detailed explanations, and real-world use cases you can adapt for your specific needs.