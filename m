From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Thu, 24 Dec 2015 13:42:41 +0200
Message-ID: <20151224114241.GA5119@intel.com>
References: <9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com>
	<20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>
	<n5ed19$pqo$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <n5ed19$pqo$1@ger.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Dec 23, 2015 at 10:02:05AM -0500, Ken Goldman wrote:
> On 12/22/2015 4:23 PM, Jason Gunthorpe wrote:
> >
> > I'd be alarmed if it is that much. The TPM format is very amenable to
> > doing this, a well designed table driven approach should be quite
> > small on the rpc handling side. The key is to not overthink/overdesign
> > it too much.
> 
> Let's expand on "alarmed".  If that just means you're surprised, OK.  If 
> it means the code will be rejected based solely on the size, please tell 
> us now.

Code is not rejected solely on its size as long as is broken up into
reasonable size and otherwise sane patches. It's impossible to give
promise on acceptance without seeing the code first.

For simple context swapping you'd have:

* One data structure per context containing virtual-physical mapping +
  shmem_file for storage.
* Generic swapping code command and response parameters. You get the
  meta-data from CAP_COMMANDS.
* Special cases for less than five commands.

Trivial swapping code would just dump transient data to shmem_file after
taking tpm_mutex and load its own mappings. Then it would do
substitution based on the meta-data given by the TPM. That's it.

It is extremely hard to imagine that one would reach source line counts
described unless the implementation is of extremely bad quality [1].

/Jarkko

[1] I'm considering here only TPM 2.0 implementation.

------------------------------------------------------------------------------
