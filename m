From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: What does error code 38 mean? -> hex vs. decimal
Date: Wed, 26 Apr 2017 13:57:55 -0400
Message-ID: <odqn2s$72s$1@blaine.gmane.org>
References: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 4/23/2017 9:32 PM, Peter Huewe wrote:
> 38=0x26= invalid post init, which means tpm did not receive tpm_startup
> command after reset.

A minor observation:

While the TPM 1.2 specification listed error codes in decimal, TPM 2.0 
uses hex, and further has a lot of bit level encoding.

Thus, for TPM 2.0, it would be easier if error messages printed TPM 
errors in hex.



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
