<script>
  import '@evidence-dev/tailwind/fonts.css';
  import '../app.css';
  import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
  export let data;
</script>

<EvidenceDefaultLayout {data} 
  logo=/tree.png
  builtWithEvidence={false}
  neverShowQueries={true}
  xProfile=https://x.com/mattppal
>
  <slot slot="content"/>
</EvidenceDefaultLayout>