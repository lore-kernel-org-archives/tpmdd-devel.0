From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/4] Autodetect TCG event log version
Date: Wed, 5 Apr 2017 14:40:53 +0300
Message-ID: <20170405114053.pihivxfnotxhsv36@intel.com>
References: <20170329074328.y5rmk5wh3rj5kgcg@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329074328.y5rmk5wh3rj5kgcg-WbvboCQVrrgDIl+Cyo8nDyLysJ1jNyTM@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 29, 2017 at 12:43:28AM -0700, Petr Vandrovec wrote:
> From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> 
> Code expects that TPM1 devices use TPM1 version of the log,
> and TPM2 devices use TPM2 version of the log.  While that
> is strongly recommended by the spec, and now required by
> Microsoft certification, there are systems that use TPM2
> chip with SHA-1 only log.

Do you have example of such system? I don't know any.

> So let's do detection based on first event in the log -
> if it is Spec ID Event03, log is crypto-agile log. otherwise
> it is SHA-1 log, or malformed bunch of bytes.

"Spec ID Event03" is not even english. Why are using it as it was
part of an english sentence? I'm not a native speaker either but
you should at least try to write understandable language.

1. What specification are you talking about?
2. What structure in that specification has this data and what
   is the purpose of that structure?
3. Which field in that structure contains this string value.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
